from hyper_shell import Shell

# Create a Shell object
shell = Shell()

# Run a shell command
result = shell.run("echo 'Hello, World!'")

# Print the result
print(result.output)

