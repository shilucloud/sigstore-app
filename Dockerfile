# ---- build stage ----
FROM golang:1.25-alpine AS builder

WORKDIR /src
COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/server main.go

# ---- final stage ----
FROM scratch

COPY --from=builder /bin/server /server

EXPOSE 8080

ENTRYPOINT ["/server"]