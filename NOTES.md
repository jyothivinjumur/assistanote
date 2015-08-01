
### Migrations
```
rails generate model prnode pgid:integer:index pgnodename:string:index pgscore:decimal

rails generate model termscore term:string:index score:decimal

rake db:migrate

rails g migration pgscore_type_in_prnode

rails g controller prnode new create

bundle exec rails g migration ChangeTermScorePrecision

bundle exec rails g migration AddUserType

```

### Some random stuff
```
############################
# 1. read from,to,cc into arrays
    # 2. figure out how to query the prnodes table  
    # this takes a hash of options, almost all of which map directly
    # to the familiar database.yml in rails
    # See http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/MysqlAdapter.html
    # client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "anotassist_dev")
    # client = Client.find(2)

    # results = client.query("SELECT * FROM prnodes as p WHERE p.pgnodename='"+fromArray+"'") do |row|
    #   puts "Our Query Results"
    #   puts row
    # end 
     

    # Read the To and From address into a local vairable and compare with db values
    # color accordingly 


    <!-- 
  <div class="container">
    <div class="row">
      <div class="span9"><%= yield %></div>
      <div class="span3">
        <h4>Help</h4>
        You can click here to learn more ... bla bla bla
      </div>
    </div>
  </div> -->

  #####################################
```


### Relating relations table with email
```
# run the following command
update relations r
join emails e on r.email = e.reference_id
set r.email_id = e.id;
```

### Clean files
```
files = `ls p/*`
files = files.gsub!("p/","")
files = files.split("\n")

email = open("emails.csv", 'w')
attachement = open("attachements.csv", 'w')

files.each do |f|
  if(f.split(".").count == 4)
    email.write("#{f}\n")
  else
    attachement.write("#{f}\n")
  end
end
```

### Joining attachements with emails
```
UPDATE attachments a
JOIN emails e ON SUBSTRING_INDEX( a.reference_id , '.', 3 ) = SUBSTRING_INDEX( e.reference_id , '.', 3 )
SET a.email_id = e.id
```

### Colors dont show up on Heroku, which requires a special step
```
bundle exec rake assets:precompile
git add .
git commit -a
git push
```