REBAR=$(shell which rebar 2> /dev/null || echo ./rebar)
RPC_SRC_FILES = rpc/pmap.erl rpc/pmap.x rpc/rpc_client.erl rpc/rpc_app.erl rpc/rpc_proto.erl rpc/rpc_server_sup.erl rpc/rpc_server.app.src rpc/rpc.x 
RPC_DST_FILES = rpc/pmap_clnt.erl rpc/pmap_xdr.erl rpc/pmap.hrl rpc/rpc_clnt.erl rpc/rpc_xdr.erl rpc/rpc.hrl

.PHONY: deps compile

all: compile

./rebar:
	erl -noshell -s inets start -s ssl start \
		-eval 'httpc:request(get, {"https://github.com/downloads/basho/rebar/rebar", []}, [], [{stream, "./rebar"}])' \
		-s inets stop -s init stop
	chmod +x ./rebar

deps : $(REBAR)
	@$(REBAR) get-deps

compile: $(REBAR) deps
	@$(REBAR) compile
	@erl -noshell -pa ../ebin -eval 'file:set_cwd("rpc")' -eval 'erpcgen:file(pmap, [xdrlib,clnt])' -s init stop
	@erl -noshell -pa ../ebin -eval 'file:set_cwd("rpc")' -eval 'erpcgen:file(rpc, [xdrlib,clnt])' -s init stop
	@mkdir -p rpc_server/src
	@cp -r rpc/* rpc_server/src/
	@$(REBAR) compile

clean: $(REBAR)
	@$(REBAR) clean
	@rm -f $(RPC_DST_FILES)
	@rm -rf rpc_server
