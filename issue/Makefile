.PHONY: ensure_root
ensure_root:
	@cd .. && make --silent ensure_root

%: issue-% ensure_root
	ln -rs $< /etc/issue
