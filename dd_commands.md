#DB commands
Export data 
psql -d smsrace -c '\copy passages to stdout CSV HEADER' > passages.csv

psql -d smsrace -c '\copy participants to stdout CSV HEADER' > participants.csv

Create temp table
```
create table temp_participants(nr int, name varchar, race_id int, phonenumber varchar);
```

fick skapa tabellen utan temporary eftersom jag inte fick köra copy kommadot

töm gamla passager
Truncate messages cascade;
truncate participants cascade;

Import from csv
```
copy temp_participants(nr, name, race_id, phonenumber)
from '<participants.csv>'
delimiter ';'
csv header;

eller

\copy temp_participants from '/home/deploy/participants_2025.csv' delimiter ';' csv header;

```

Select from temp_participants into participants with now as date
```
insert into participants (nr, name, race_id, phonenumber, inserted_at, updated_at) 
select nr, name, race_id, phonenumber, now() as inserted_at, now() as updated_at
from temp_participants;
```

