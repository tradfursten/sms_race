{:ok, race_seven} = Smsrace.SMSRace.create_race(%{name: "Marsliden 7 sumit", start: DateTime.utc_now()})
Smsrace.SMSRace.create_checkpoint(%{name: "Stöken", code: "stöken", distance: 7, race_id: race_seven.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Ropen", code: "ropen", distance: 7, race_id: race_seven.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Ainan", code: "ainan", distance: 7, race_id: race_seven.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Ortsen", code: "ortsen", distance: 7, race_id: race_seven.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Gakkan", code: "gakkan", distance: 7, race_id: race_seven.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Marsfjället", code: "marsfjället", distance: 7, race_id: race_seven.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Såttan", code: "såttan", distance: 7, race_id: race_seven.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Mål", code: "mål", distance: 7, race_id: race_seven.id})

Smsrace.SMSRace.create_participant(%{nr: 1, name: "Kate Clemons", phonenumber: "1", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 2, name: "Osman Paul", phonenumber: "2", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 3, name: "Muskaan Bullock", phonenumber: "3", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 4, name: "Sabiha Acosta", phonenumber: "4", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 5, name: "Agnes Navarro", phonenumber: "5", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 6, name: "Carl Mcgowan", phonenumber: "6", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 7, name: "Asiya Walter", phonenumber: "7", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 8, name: "Liyana Fuentes", phonenumber: "8", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 9, name: "Zaara Norman", phonenumber: "9", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 10, name: "Elias Stafford", phonenumber: "10", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 11, name: "Amy-Leigh Lynn", phonenumber: "11", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 12, name: "Teresa Harmon", phonenumber: "12", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 13, name: "Keeleigh Robertson", phonenumber: "13", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 14, name: "Fahima Kaiser", phonenumber: "14", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 15, name: "Liya Donaldson", phonenumber: "15", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 16, name: "Gillian Rose", phonenumber: "16", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 17, name: "Malakai Mckeown", phonenumber: "17", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 18, name: "Cristian Huber", phonenumber: "18", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 19, name: "Danyaal Green", phonenumber: "19", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 20, name: "Mahir Nicholson", phonenumber: "20", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 21, name: "Skylar Charles", phonenumber: "21", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 22, name: "Szymon Whitworth", phonenumber: "22", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 23, name: "Sofija Wicks", phonenumber: "23", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 24, name: "Fox Mellor", phonenumber: "24", race_id: race_seven.id})
Smsrace.SMSRace.create_participant(%{nr: 25, name: "Genevieve Adamson", phonenumber: "25", race_id: race_seven.id})

{:ok, race_three} = Smsrace.SMSRace.create_race(%{name: "Marsliden 3 sumit", start: DateTime.utc_now()})
Smsrace.SMSRace.create_checkpoint(%{name: "Ainan", code: "ainan", distance: 7, race_id: race_three.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Ortsen", code: "ortsen", distance: 7, race_id: race_three.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Gakkan", code: "gakkan", distance: 7, race_id: race_three.id})
Smsrace.SMSRace.create_checkpoint(%{name: "Mål", code: "mål", distance: 7, race_id: race_three.id})

Smsrace.SMSRace.create_participant(%{nr: 1, name: "Ravinder Tait", phonenumber: "01", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 2, name: "Miyah Rodriquez", phonenumber: "02", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 3, name: "Momina Devlin", phonenumber: "03", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 4, name: "Billie Horne", phonenumber: "04", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 5, name: "Rhodri Esquivel", phonenumber: "05", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 6, name: "Jason Richardson", phonenumber: "06", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 7, name: "Subhan Bass", phonenumber: "07", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 8, name: "Kirstie Odonnell", phonenumber: "08", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 9, name: "Russell Woodard", phonenumber: "09", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 10, name: "Kobi Carlson", phonenumber: "010", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 11, name: "Kendal Diaz", phonenumber: "011", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 12, name: "Teresa Harmon", phonenumber: "012", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 13, name: "Shanai Holmes", phonenumber: "013", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 14, name: "Cheryl Liu", phonenumber: "014", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 15, name: "Braden Newman", phonenumber: "015", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 16, name: "Zain Farmer", phonenumber: "016", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 17, name: "Mikael Coleman", phonenumber: "017", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 18, name: "Ainsley Koch", phonenumber: "018", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 19, name: "Chenai Carey", phonenumber: "019", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 20, name: "Eilish Burgess", phonenumber: "020", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 21, name: "Maverick Schneider", phonenumber: "021", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 22, name: "Laurel Blackwell", phonenumber: "022", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 23, name: "Camilla Chapman", phonenumber: "023", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 24, name: "Marian Xiong", phonenumber: "024", race_id: race_three.id})
Smsrace.SMSRace.create_participant(%{nr: 25, name: "Arabella Chadwick", phonenumber: "025", race_id: race_three.id})














