run:
	docker-compose run api rake db:create
	docker-compose run api rake db:migrate
