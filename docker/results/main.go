package main

import (
	"database/sql"
	"html/template"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/gorilla/websocket"
	_ "github.com/jackc/pgx/v5/stdlib"
)

type ResultsModel struct {
	OptionA   int `json:"optionA"`
	OptionB   int `json:"optionB"`
	VoteCount int `json:"voteCount"`
}

func GetResults(db *sql.DB) (ResultsModel, error) {
	rows, err := db.Query(`SELECT vote, COUNT(id) AS count 
                           FROM votes GROUP BY vote ORDER BY vote`)
	if err != nil {
		return ResultsModel{}, err
	}
	defer rows.Close()

	var optionA, optionB int
	for rows.Next() {
		var vote string
		var count int
		if err := rows.Scan(&vote, &count); err != nil {
			return ResultsModel{}, err
		}
		if vote == "a" {
			optionA = count
		} else if vote == "b" {
			optionB = count
		}
	}
	if err = rows.Err(); err != nil {
		return ResultsModel{}, err
	}

	return ResultsModel{
		OptionA:   optionA,
		OptionB:   optionB,
		VoteCount: optionA + optionB,
	}, nil
}

type Client struct {
	hub  *Hub
	conn *websocket.Conn
	send chan ResultsModel
}

type Hub struct {
	clients    map[*Client]bool
	broadcast  chan ResultsModel
	register   chan *Client
	unregister chan *Client
}

func NewHub() *Hub {
	return &Hub{
		clients:    make(map[*Client]bool),
		broadcast:  make(chan ResultsModel),
		register:   make(chan *Client),
		unregister: make(chan *Client),
	}
}

func (h *Hub) Run() {
	for {
		select {
		case client := <-h.register:
			h.clients[client] = true
		case client := <-h.unregister:
			if _, ok := h.clients[client]; ok {
				delete(h.clients, client)
				close(client.send)
			}
		case message := <-h.broadcast:
			for client := range h.clients {
				select {
				case client.send <- message:
				default:
					close(client.send)
					delete(h.clients, client)
				}
			}
		}
	}
}

const writeWait = 10 * time.Second

func (c *Client) writePump() {
	ticker := time.NewTicker(30 * time.Second)
	defer func() {
		ticker.Stop()
		c.conn.Close()
	}()
	for {
		select {
		case message, ok := <-c.send:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if !ok {
				c.conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}
			if err := c.conn.WriteJSON(message); err != nil {
				return
			}
		case <-ticker.C:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if err := c.conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}
}

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true },
}

func serveWs(hub *Hub, w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("WebSocket upgrade error:", err)
		return
	}
	client := &Client{hub: hub, conn: conn, send: make(chan ResultsModel, 256)}
	client.hub.register <- client

	go client.writePump()

	go func() {
		defer func() {
			client.hub.unregister <- client
			conn.Close()
		}()
		for {
			if _, _, err := conn.ReadMessage(); err != nil {
				break
			}
		}
	}()
}

func startPublisher(hub *Hub, db *sql.DB, interval time.Duration) {
	ticker := time.NewTicker(interval)
	go func() {
		for range ticker.C {
			results, err := GetResults(db)
			if err != nil {
				log.Printf("Error fetching results: %v", err)
				continue
			}
			hub.broadcast <- results
		}
	}()
}

func main() {
	dbConnStr := os.Getenv("DB_CONN_STRING")
	if dbConnStr == "" {
		log.Fatal("DB_CONN_STRING environment variable is required")
	}

	optionA := getEnv("VOTING_OPTION_A", "Cats")
	optionB := getEnv("VOTING_OPTION_B", "Dogs")
	interval := getDurationEnv("PUBLISH_INTERVAL_MS", 5*time.Second)

	db, err := sql.Open("pgx", dbConnStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	if err = db.Ping(); err != nil {
		log.Fatal("Cannot ping database:", err)
	}
	log.Println("Connected to PostgreSQL")

	hub := NewHub()
	go hub.Run()

	startPublisher(hub, db, interval)

	http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("/app/static/css"))))

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			http.NotFound(w, r)
			return
		}

        w.Header().Set("Cache-Control", "no-cache, no-store, must-revalidate")
        w.Header().Set("Pragma", "no-cache")
        w.Header().Set("Expires", "0")

		tmpl, err := template.ParseFiles("templates/index.html")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		data := struct {
			OptionA string
			OptionB string
		}{optionA, optionB}
		tmpl.Execute(w, data)
	})

	http.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		serveWs(hub, w, r)
	})

	log.Println("Server starting on :5001")
	log.Fatal(http.ListenAndServe(":5001", nil))
}

func getEnv(key, defaultValue string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return defaultValue
}

func getDurationEnv(key string, defaultValue time.Duration) time.Duration {
	if v := os.Getenv(key); v != "" {
		if ms, err := strconv.Atoi(v); err == nil && ms > 0 {
			return time.Duration(ms) * time.Millisecond
		}
	}
	return defaultValue
}
