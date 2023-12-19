# research-project-julia

## Running the project
In order to run the project, you should cd into the project directory `/path/to/project/directory` and then use the following command
```console
user:~$ julia --project=. main.jl
```

### Language version update
When updating the installed Julia language version, this project should be updated using the following commands:
```console
pkg> activate "/path/to/project/directory"
pkg> update
```