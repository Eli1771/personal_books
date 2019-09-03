require 'csv'
#require 'vhp_test_data'

class CsvParser

  @@vhp = File.open('vhp_test_data.csv', 'r')

  def self.parse
    self.new.call
  end

  def call
    #actually does all the parsing
    as_array = CSV.parse(@@vhp)
  end





  # @@vhp = "TITLE,AUTHOR'S FIRST,AUTHOR'S LAST,TOPIC,LOCATION,CASE,SHELF
  # Spirit Empowered Preaching: Involving The Holy Spirit in your Ministry,Arturo G.,Azurdia III,Biblical Exposition: Preaching,library,9,4
  # Speaking with Bold Assurance,Bert,Decker & Herschel W. York,Biblical Exposition: Preaching,library,9,4
  # Handbook of Contemporary Preaching,Michael,Duduit,Biblical Exposition: Preaching,library,9,4
  # Preaching & Preachers,D. Martyn,Lloyd-Jones,Biblical Exposition: Preaching,library,9,4
  # Expository Preaching,John,\"MacArthur, Jr.\",Biblical Exposition: Preaching,library,9,4
  # Anointed Expository Preaching,Stephen F.,Olford,Biblical Exposition: Preaching,library,9,4
  # The Supremacy of God in Preaching,John,Piper,Biblical Exposition: Preaching,library,9,4
  # Doctrine that Dances: Bringing Doctrinal Preaching and Teaching to Life,Robert,Smith Jr.,Biblical Exposition: Preaching,library,9,4
  # A Guide to Effective Sermon Delivery,Jerry ,Vines,Biblical Exposition: Preaching,library,9,4
  # Preaching with Bold Assurance,Herschel W.,York,Biblical Exposition: Preaching,library,9,4
  # Iron Shoes,C. Roy,Angell,Biblical Exposition: Sermons,library,9,5
  # The Crook in the Lot,Thomas,Boston,Biblical Exposition: Sermons,library,9,5
  # God Leaves the Lights On,Blake,Carroll,Biblical Exposition: Sermons,library,9,5
  # Basic Bible Sermons on The Cross,W.A.,Criswell,Biblical Exposition: Sermons,library,9,5
  # With A Bible In My Hand,W.A.,Criswell,Biblical Exposition: Sermons,library,9,5
  # Other Preacher' Bones,Francis W. ,Dixon,Biblical Exposition: Sermons,library,9,5
  # Basic Bible Sermons on Psalms for Everyday Living,James T.,\"Draper, Jr.\",Biblical Exposition: Sermons,library,9,5
  # Christian Love and Its Fruits,Jonathan,Edwards,Biblical Exposition: Sermons,library,9,5
  # Basic Bible Sermons on Hope,David Albert,Farmer,Biblical Exposition: Sermons,library,9,5
  # Basic Bible Sermons on Christmas,Chevis F.,Horne,Biblical Exposition: Sermons,library,9,5
  # Basic Bible Sermons on Easter,Chevis F.,Horne,Biblical Exposition: Sermons,library,9,5
  # The Best of A.W. Tozer,Baker Book,House,Biblical Exposition: Sermons,library,9,5
  # The Best of C.H. Spurgeon,Baker Book,House,Biblical Exposition: Sermons,library,9,5
  # Basic Bible Sermons on Spiritual Living,Stephen B. ,McSwain,Biblical Exposition: Sermons,library,9,5"






end
