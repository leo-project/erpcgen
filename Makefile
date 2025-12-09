.PHONY: all compile clean distclean dialyzer xref test

REBAR := rebar3

all: compile

compile:
	@$(REBAR) compile

clean:
	@$(REBAR) clean
	@rm -rf rpc_server
	@rm -f test/test_xdr.erl test/test.hrl test/test_clnt.erl test/test_svc.erl

distclean: clean
	@rm -rf _build
	@rm -rf rpc_server

dialyzer:
	@$(REBAR) dialyzer

xref:
	@$(REBAR) xref

test: compile
	@cd test && \
	erl -pa ../_build/default/lib/erpcgen/ebin -noshell -eval \
		"erpcgen:file(test, [xdrlib]), halt()."
	@erlc -pa _build/default/lib/erpcgen/ebin -o test test/test_xdr.erl
	@erlc -pa _build/default/lib/erpcgen/ebin -o test test/test.erl
	@erl -pa _build/default/lib/erpcgen/ebin -pa test -noshell -eval \
		"test:all(), io:format(\"All tests passed!~n\"), halt()."
