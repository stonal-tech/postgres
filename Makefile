
docker-build:
	docker build -t postgres-full .  2>&1 | tee build.log
