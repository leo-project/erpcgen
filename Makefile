.PHONY: deps compile
REBAR := ./rebar

all: compile

deps : $(REBAR)
	@$(REBAR) get-deps

compile: $(REBAR) deps
	@$(REBAR) compile
clean: $(REBAR)
	@$(REBAR) clean
	@rm -f $(RPC_DST_FILES)
	@rm -rf rpc_server
distclean:
	@$(REBAR) delete-deps
	@rm -f $(RPC_DST_FILES)
	@rm -rf rpc_server
	@$(REBAR) clean
