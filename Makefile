SOLVER = gecode

.PHONY: test
test: $(patsubst %.dzn,%,$(wildcard *.dzn))

%: %.dzn
	minizinc --solver $(SOLVER) -a -s model.mzn $< --fzn $@.fzn | tee $@.txt
