# udpwatch
micro udp listener

## Usage

This project uses nix flakes, so you can compile and run this small app using the nix command:

Run (on port 1234):
```bash
nix run .#udpwatch 1234
```

Just build to result
```bash
nix build .
```

This project also includes a simple sender:

```bash
nix run .#udpmessage 127.0.0.1:1234 Hello World!\n
```
