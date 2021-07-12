# Testing with GoMock

- From [Testing with GoMock: A Tutorial](https://blog.codecentric.de/en/2017/08/gomock-tutorial/).

- **Gmock** is a mocking library in Go


## Using GoMock with go generate

- Add `// go:generate mockgen` to files where you want to generate mocks
- Use `go generate ./...` to generate all mocks