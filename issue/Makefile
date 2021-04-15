.PHONY: ensure_root
ensure_root:
	@cd .. && make --silent ensure_root

%: issue-% ensure_root
	ln -s $(realpath $<) /etc/issue
