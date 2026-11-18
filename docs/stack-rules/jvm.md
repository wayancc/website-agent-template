# JVM (Java / Kotlin) Rule Pack

Covers: Spring Boot (Java or Kotlin) with Thymeleaf or a JS front end; Quarkus, Micronaut, Ktor follow the same principles.

## Recommended defaults
- Spring Boot + Thymeleaf (server-rendered) + htmx for most sites; Kotlin if the team prefers it.
- Build tool: Gradle (Kotlin DSL) with the wrapper committed — or Maven wrapper if the team uses Maven.

## scripts/check.sh (Gradle; Maven equivalents in comments)
```bash
install() { ./gradlew --no-daemon --quiet dependencies > /dev/null; }  # ./mvnw -B -q dependency:go-offline
lint()    { ./gradlew --no-daemon spotlessCheck; }                      # ./mvnw -B spotless:check · Kotlin: ktlint/detekt
types()   { ./gradlew --no-daemon compileJava compileTestJava; }        # Kotlin: compileKotlin compileTestKotlin · ./mvnw -B test-compile
test_()   { ./gradlew --no-daemon test; }                               # ./mvnw -B test
build()   { ./gradlew --no-daemon bootJar; }                            # ./mvnw -B package -DskipTests
```

## Version file
`.java-version` (CI reads it) + Java toolchain in the build file.

## Project structure & web root
Standard layout (`src/main/java|kotlin`, `src/main/resources/templates`, `src/main/resources/static`). Only `static/` content is served directly.

## Coding rules
- Constructor injection; no field injection.
- Controllers thin; logic in services; DTOs for request/response.
- Schema changes via Flyway or Liquibase migrations.

## Security
- **Spring Security:** CSRF stays enabled for server-rendered forms (Thymeleaf adds the token).
- **Database:** Spring Data / JPA parameters or `JdbcTemplate` with `?` placeholders. Never concatenate input into JPQL/SQL.
- **Templates:** `th:text` (escaped); `th:utext` only for trusted HTML.
- **Actuator:** expose only `health` publicly; everything else secured.
- **Secrets:** environment variables or a secret manager — not committed in `application.properties`/`.yml`.
- **Audit:** OWASP Dependency-Check plugin or Dependabot alerts.

## Performance & SEO
- Static resource caching with content hashes; HTTP compression on.
- Avoid N+1 (fetch joins / entity graphs).

## .gitignore additions
```
build/
target/
.gradle/
*.class
```

## CI notes
Java setup automatic (reads `.java-version`). Add a database service or use Testcontainers (Docker is available on GitHub runners).

## Hosting & previews
Containers (Cloud Run, Azure Container Apps, AWS ECS/App Runner, Fly.io) or VPS. Usually a staging environment.

## Reviewer checks
- [ ] No `th:utext` on user data; no concatenated queries
- [ ] CSRF not disabled; Actuator locked down
- [ ] Migration included for schema changes
- [ ] Dependency check: no unresolved high/critical
