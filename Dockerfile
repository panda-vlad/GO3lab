FROM golang:1.14 as build

RUN apt-get update && apt-get install -y ninja-build

# TODO: Змініть на власну реалізацію системи збірки

WORKDIR /go/src
RUN git clone https://github.com/Vlad1slavIP74/2lab
WORKDIR 2lab/
RUN go get -u github.com/Vlad1slavIP74/2lab/build/cmd/bood
WORKDIR build/
RUN bood

WORKDIR /go/src/practice-3
COPY . .

RUN CGO_ENABLED=0 /go/src/2lab/build/out/bin/bood

# ==== Final image ====
FROM alpine:3.11
WORKDIR /opt/practice-3
COPY entry.sh ./
COPY --from=build /go/src/practice-3/out/bin/* ./
ENTRYPOINT ["/opt/practice-3/entry.sh"]
CMD ["server"]
