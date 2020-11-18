# watch a chained command
watch 'docker ps --format "{{.ID}},{{.Image}},{{.Ports}},{{.Status}}" | tty-table'