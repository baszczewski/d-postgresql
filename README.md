baszczewski-postgresql
==================

Usage
-----

To create the image `baszczewski/postgresql`, execute the following command on the folder:

	docker build -t baszczewski/postgresql .

Running
------------------------------

**developer option**

* expose port to host (insecure);

```bash
docker run -d -p 5432:5432 -p 5050:5050 -e 'DB_USER=user' -e 'DB_PASS=password' --name postgresql baszczewski/postgresql 
```