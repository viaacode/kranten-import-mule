# Kranten import mule

This project glues together the microservices that can create a <pid>.complex. Ik can be
initialized by placing a message on its trigger queue. This message should contain the
pid, the directory to turn into a `.complex` file and the metadata that should be placed
in the mets file (see mets-listener in node microservices).

To function properly the mule flows use a database to keep track of information on a
specific directory. The table that it uses can be created with

```sql
CREATE TABLE tracktable (
	pid character(50) NOT NULL,
	status character(100),
	data text,
	nr_of_moves integer,
	nr_of_moved integer DEFAULT 0
);
```

You can restart the generation of a mets file by placing a message on the recover queue.
This message should contain the pid of a partially genarted complex file.

example:

```json
{
	"pid": "4746q1wv0v"
}
```

The `_complex` directory will then be removed, and the generation starts from scratch.
