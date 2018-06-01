IP := $(shell ip route ls | grep default | awk '{print $$9}')

build:
	echo -e "\033[0;32mBuilding site...\033[0m"
	hugo -t nofancy

install: build
	echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
	cd public; \
	git add -A; \
	git commit -m "rebuilding site `date`"; \
	git push origin master

dev:
	hugo server -t nofancy -w -D --bind $(IP) -b $(IP)
