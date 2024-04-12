FROM golang:1.22.2-alpine3.19 as builder

WORKDIR /app

COPY . .

RUN go build -o wrapto .

EXPOSE 3000

CMD ["./wrapto"]
