# hugo-devkit

Batteries-included Hugo starter kit for local development and deployment. 

## Getting started

Prerequisites: Docker and Make.

1. Start the development server:
```sh
make dev      # Starts the local server with live reload
```

2. head over to ```http://localhost:1313``` for live preview

3. start building!

### Available commands:
```sh
make test     # Run the example and compatibility checks
make dev      # Start the local server; accessible at http://localhost:1313
make publish  # Start the local server; accessible at http://localhost:1313 and <your-maschine-ip:1313> 
make build    # Build the production site
```

## Live preview

[leetsheep.github.io/hugo-devkit](https://leetsheep.github.io/hugo-devkit/)

## License

[MIT](LICENSE)
