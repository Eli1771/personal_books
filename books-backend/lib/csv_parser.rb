require 'csv'
#require 'vhp_test_data'

class CsvParser

  #vhp = File.open('vhp_test_data.csv', 'r')

  def self.clear_library
    Book.all.each {|b| b.delete}
    Case.all.each {|c| c.delete}
    Room.all.each {|r| r.delete}
    Topic.all.each {|t| t.delete}
    Author.all.each {|a| a.delete}
    BookAuthor.all.each {|ba| ba.delete}
  end

  def self.parse
    self.new.call
  end

  def call
    #actually does all the parsing
    as_array = CSV.parse(@@vhp)
    for_out = []

    as_array.each do |row|
      book = make_book(row)
      for_out << book
    end
    for_out
  end

  def make_book(row)
    #stub book
    book = Book.new(title: row[0])
    #grab user
    user = User.find_by_id(8)
    #create room w/ associations
    room = Room.find_or_create_by(name: row[4])
    associate_user(room, user)
    #create case w/ associations
    bookcase = Case.find_or_create_by(name: row[5])
    bookcase.room_id = room.id
    if bookcase.shelf_count && bookcase.shelf_count < row[6]
      bookcase.shelf_count = row[6]
    end
    associate_user(bookcase, user)
    #create authors array containing Author objects
    authors = []
    author_name = "#{row[1]} + #{row[2]}"
    if author_name.include?('&')
      author_names = author_name.split(' & ')
      author_names.each do |name|
        author = Author.find_or_create_by(name: name)
        associate_user(author, user)
        authors << author
      end
    else
      author = Author.find_or_create_by(name: author_name)
      associate_user(author, user)
      authors << author
    end
    #create topic w/ associations
    topic = Topic.find_or_create_by(name: row[3])
    associate_user(topic, user)
    #assign all attributes to book stub
    book.case_id = bookcase.id
    book.shelf_id = row[6]
    book.room_id = room.id
    book.topic_id = topic.id
    book.user_id = user.id
    #create join objects for books/authors
    authors.each do |author|
      BookAuthor.create(book_id: book.id, author_id: author.id)
    end
    #save and return book
    book.save
    book
  end

  def associate_user(model, user)
    model.user_id = user.id
    model.save
  end





  @@vhp = "TITLE,AUTHOR'S FIRST,AUTHOR'S LAST,TOPIC,LOCATION,CASE,SHELF
  Spirit Empowered Preaching: Involving The Holy Spirit in your Ministry,Arturo G.,Azurdia III,Biblical Exposition: Preaching,library,9,4
  Speaking with Bold Assurance,Bert,Decker & Herschel W. York,Biblical Exposition: Preaching,library,9,4
  Handbook of Contemporary Preaching,Michael,Duduit,Biblical Exposition: Preaching,library,9,4
  Preaching & Preachers,D. Martyn,Lloyd-Jones,Biblical Exposition: Preaching,library,9,4
  Expository Preaching,John,\"MacArthur, Jr.\",Biblical Exposition: Preaching,library,9,4
  Anointed Expository Preaching,Stephen F.,Olford,Biblical Exposition: Preaching,library,9,4
  The Supremacy of God in Preaching,John,Piper,Biblical Exposition: Preaching,library,9,4
  Doctrine that Dances: Bringing Doctrinal Preaching and Teaching to Life,Robert,Smith Jr.,Biblical Exposition: Preaching,library,9,4
  A Guide to Effective Sermon Delivery,Jerry ,Vines,Biblical Exposition: Preaching,library,9,4
  Preaching with Bold Assurance,Herschel W.,York,Biblical Exposition: Preaching,library,9,4
  Iron Shoes,C. Roy,Angell,Biblical Exposition: Sermons,library,9,5
  The Crook in the Lot,Thomas,Boston,Biblical Exposition: Sermons,library,9,5
  God Leaves the Lights On,Blake,Carroll,Biblical Exposition: Sermons,library,9,5
  Basic Bible Sermons on The Cross,W.A.,Criswell,Biblical Exposition: Sermons,library,9,5
  With A Bible In My Hand,W.A.,Criswell,Biblical Exposition: Sermons,library,9,5
  Other Preacher' Bones,Francis W. ,Dixon,Biblical Exposition: Sermons,library,9,5
  Basic Bible Sermons on Psalms for Everyday Living,James T.,\"Draper, Jr.\",Biblical Exposition: Sermons,library,9,5
  Christian Love and Its Fruits,Jonathan,Edwards,Biblical Exposition: Sermons,library,9,5
  Basic Bible Sermons on Hope,David Albert,Farmer,Biblical Exposition: Sermons,library,9,5
  Basic Bible Sermons on Christmas,Chevis F.,Horne,Biblical Exposition: Sermons,library,9,5
  Basic Bible Sermons on Easter,Chevis F.,Horne,Biblical Exposition: Sermons,library,9,5
  The Best of A.W. Tozer,Baker Book,House,Biblical Exposition: Sermons,library,9,5
  The Best of C.H. Spurgeon,Baker Book,House,Biblical Exposition: Sermons,library,9,5
  Basic Bible Sermons on Spiritual Living,Stephen B. ,McSwain,Biblical Exposition: Sermons,library,9,5"






end
