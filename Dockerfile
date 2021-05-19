FROM golang:1.15 as builder

WORKDIR $GOPATH/src/github.com/btcsuite/btcd

# Grab and install the latest version of roasbeef's fork of btcd and all
# related dependencies.
RUN git clone -b v0.21.0-beta https://github.com/btcsuite/btcd . \
&&  GO111MODULE=on go install -v . ./cmd/...

# Start a new image
FROM ubuntu as final

# Expose mainnet ports (server, rpc)
EXPOSE 8333 8334

# Expose testnet ports (server, rpc)
EXPOSE 18333 18334

# Expose simnet ports (server, rpc)
EXPOSE 18555 18556

# Expose segnet ports (server, rpc)
EXPOSE 28901 28902

# Copy the compiled binaries from the builder image.
COPY --from=builder /go/bin/addblock /bin/
COPY --from=builder /go/bin/btcctl /bin/
COPY --from=builder /go/bin/btcd /bin/
COPY --from=builder /go/bin/findcheckpoint /bin/
COPY --from=builder /go/bin/gencerts /bin/

RUN mkdir "/rpc" "/root/.btcd" "/root/.btcctl" \
&&  touch "/root/.btcd/btcd.conf"

VOLUME ["/data"]

ENTRYPOINT ["btcd"]
