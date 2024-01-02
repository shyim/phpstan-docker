# Small PHPStan Docker image

This image is using Ubuntu Chisel to create a very small PHPStan Docker image and using still glibc, to be used in CI/CD pipelines.

## Usage

```bash
# or alternative use ghcr.io/shyim/phpstan:latest
docker run --rm -v (pwd):(pwd) -w (pwd) shyim/phpstan:latest analyse .
```

If you don't want to pass the as arguments, you can create your regular `phpstan.neon` file and PHPStan will pick it up as usual.
