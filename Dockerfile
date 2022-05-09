FROM rust as builder

ADD . /serum-dex
WORKDIR /serum-dex/dex/fuzz
RUN apt-get update && apt-get install -y pkg-config build-essential python3-pip jq git
RUN git apply /serum-dex/dex/patches/instructions.patch

RUN rustup toolchain add nightly
RUN rustup default nightly
RUN cargo +nightly install -f cargo-fuzz
RUN rustup component add rustfmt

RUN cargo +nightly fuzz build

FROM ubuntu:20.04

COPY --from=builder /serum-dex/dex/fuzz/target/x86_64-unknown-linux-gnu/release/multiple_orders /
