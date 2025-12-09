# erpcgen

Erlang RPC Stub Generator - A code generator for Sun ONC/RPC (RFC 1831/1832) client and server stubs.

## Overview

erpcgen generates Erlang source code from XDR (External Data Representation) specification files (`.x` files). It creates encoder/decoder modules, client stubs, and server stubs for building RPC-based distributed systems in Erlang.

This package conforms to RFC 1831 (RPC) and RFC 1832 (XDR).

## Features

- Generate XDR encoder/decoder modules from `.x` specification files
- Generate RPC client stub modules
- Generate RPC server stub modules (gen_server or callback-based)
- Support for all XDR data types: int, hyper, float, double, bool, enum, struct, union, arrays, strings, opaque
- TCP and UDP protocol support

## Requirements

- Erlang/OTP 22 or later (tested up to OTP 28)
- rebar3

## Build

```bash
make compile
# or
rebar3 compile
```

## Test

```bash
make test
```

## Usage

### API

```erlang
%% Generate all stubs (header, client, server, xdr)
erpcgen:file(proto).

%% Generate with specific options
erpcgen:file(proto, [client]).

%% Generate with different output basename
erpcgen:file(proto, output, [xdrlib]).
```

### Options

| Option | Description |
|--------|-------------|
| `hrl` | Generate `<Out>.hrl` header file |
| `clnt` | Generate `<Out>_clnt.erl` client module |
| `svc` | Generate `<Out>_svc.erl` server module (gen_server) |
| `svc_callback` | Generate `<Out>_svc.erl` server module (rpc_server callback) |
| `xdr` | Generate `<Out>_xdr.erl` encoder/decoder module |
| `xdr_inc` | Generate `<Out>_xdr.hrl` include file |
| `client` | Shortcut for `[hrl, clnt, xdr]` |
| `server` | Shortcut for `[hrl, svc, xdr, svc_stub]` |
| `xdrlib` | Shortcut for `[hrl, xdr]` |
| `all` | Shortcut for `[hrl, clnt, svc, xdr, svc_stub]` (default) |

### Example

Given an XDR specification file `myproto.x`:

```c
enum status {
  OK = 0,
  ERROR = 1
};

struct request {
  int id;
  string name<255>;
};

struct response {
  status stat;
  opaque data<>;
};

program MYPROTO_PROG {
  version MYPROTO_VERS {
    response PROCESS(request) = 1;
  } = 1;
} = 100000;
```

Generate the Erlang modules:

```erlang
1> erpcgen:file(myproto, [all]).
[ok,ok,ok,ok,ok]
```

This generates:
- `myproto.hrl` - Header file with constants
- `myproto_xdr.erl` - XDR encoder/decoder functions
- `myproto_clnt.erl` - Client stub functions
- `myproto_svc.erl` - Server stub functions

### XDR Data Type Representation in Erlang

| XDR Type | Erlang Representation |
|----------|----------------------|
| int, unsigned int | integer |
| hyper, unsigned hyper | integer |
| float, double | float |
| bool | `true` \| `false` |
| string | binary |
| opaque | binary |
| enum | atom (e.g., `'OK'`) |
| struct | tuple |
| union | `{Discriminant, Value}` |
| array | list |

### Generated XDR Functions

```erlang
%% Encode a term to iolist
myproto_xdr:enc_request({1, <<"hello">>}).

%% Decode binary to term
{Term, NewOffset} = myproto_xdr:dec_request(Binary, Offset).
```

## Documentation

See `doc/README` and `doc/API.txt` for detailed API documentation.

## License

Apache License 2.0

## Authors

- Original: Sendmail, Inc. (2000-2001)
- Maintained by: Lions Data, Ltd.
