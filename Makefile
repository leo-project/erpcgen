REBAR=$(shell which rebar 2> /dev/null || echo ./rebar)
RPC_SRC_FILES = rpc/pmap.erl rpc/pmap.x rpc/rpc_client.erl rpc/rpc_server.erl rpc/rpc.x 
RPC_DST_FILES = rpc/pmap_clnt.erl rpc/pmap_xdr.erl rpc/pmap.hrl rpc/rpc_clnt.erl rpc/rpc_xdr.erl rpc/rpc.hrl

all: compile

./rebar:
	erl -noshell -s inets start -s ssl start \
		-eval 'httpc:request(get, {"https://github.com/downloads/basho/rebar/rebar", []}, [], [{stream, "./rebar"}])' \
		-s inets stop -s init stop
	chmod +x ./rebar

compile: $(REBAR)
	@$(REBAR) compile

rpc: compile $(RPC_SRC_FILES)
	erl -noshell -pa ../ebin -eval 'file:set_cwd("rpc")' -eval 'erpcgen:file(pmap, [xdrlib,clnt])' -s init stop
	erl -noshell -pa ../ebin -eval 'file:set_cwd("rpc")' -eval 'erpcgen:file(rpc, [xdrlib,clnt])' -s init stop

clean: $(REBAR)
	@$(REBAR) clean
	@rm -f $(RPC_DST_FILES)
