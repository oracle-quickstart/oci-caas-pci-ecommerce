# .env loading in the shell
dotenv () {
  set -a
  [ -f .env ] && . .env
  set +a
}

# Run dotenv on login
dotenv
mvn clean
mvn spring-boot:run