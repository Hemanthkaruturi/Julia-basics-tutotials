# inbuilt package in Julia
using Sockets

server = listen(8000)

conn = accept(server)

line = readline(conn)

write(conn,"Hello Client. How are you? \n")

while true
    line = readline(con)
    println("Incoming message >>> $line")
end

close(conn)
