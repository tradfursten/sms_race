# What have I done?

Actions: 
Gen phx.gen.context
Pattern matcha med string nycklar i external api controller

ToDo:
x Enter messages into db in externalApiController
Style message list
Tie messages in live view to specific user? Skip in mvp
Match message checkpoint and participant and create passage automaticly
Enable creation of passage in message list
Secure messages live view and all crud pages
Create result list live view for a race and a checkpoint (public)
Deploy to gigalexir - extended

ToDo:
Vy för att välja participant
Spara val av participant
Vy för att väja checkpoint
Spara val av checkpoint
Sorerings val för messages
Filtrera messages, handled, skriva text
Klickbara länkar i message from
Länka till en vy för en person
Länka till en vy för en checkpoint



Create project
`mix phx.new smsrace --live`

Followed Lars PETAL guide [https://underjord.io/getting-started-with-petal.html]

Added phx auth
`mix phx.gen.auth Accounts User users`

Generated Race
`mix phx.gen.html SMSRace Race races name:string start:utc_datetime user_id:references:users`

Generated Participants
`mix phx.gen.html SMSRace Participant participants nr:integer name:string phonenumber:string race_id:references:race`

Should I have used another module name?

Generate checkpoint
`mix phx.gen.html SMSRace Checkpoint checkpoints name:string distance:float cutoff:utc_datetime code:string race_id:references:race`

Generate passage
`mix phx.gen.html SMSRace Passage passages at:utc_datetime checkpoint_id:references:checkpoint participant_id:references:participant`

Generate messages
`mix phx.gen.html SMSRace Message messages api_id:string from:string to:string message:string direction:string created:utc_datetime`


{:ok, race} = Smsrace.SMSRace.create_race(%{name: "Marsliden 7 sumit", start: DateTime.utc_now()})

Smsrace.SMSRace.create_message(%{api_id: "123", from: "123", to: "123", created: DateTime.utc_now(), direction: "incoming", message: "Hello world"})


Smsrace.SMSRace.create_participant(%{name: "Adam", nr: 3, phonenumber: "2", race_id: 2})

Smsrace.SMSRace.create_checkpoint(%{name: "Stöken", code: "stöken", distance: 7, race_id: race.id})


