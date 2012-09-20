class ClubTrip < ActiveRecord::Base
  attr_accessible :trip, :swhen, :where, :meet, :e_room, :limit, :leader, :contact

  require "stringio"

  def self.read(file)
    CSV.parse(file, :headers => true) do |opts|
      t = self.new
      t.trip = opts["Trip"]
      t.swhen = opts["When"]
      t.where = opts["Where"]
      t.meet = opts["Meet"]
      t.e_room = opts["E-Room"]
      t.limit = opts["Limit"]
      t.leader = opts["Leader"]
      t.contact = opts["Contact"]
      t.save
    end
  end

  def self.to_csv
    ts = ClubTrip.all
    if (ts.empty?)
      CSV::Table.new(
                     [FasterCSV::Row.new(["Trip","When","Where","Meet",
                                      "E-Room","Limit","Leader","Contact"],
                       ["","","","","","","",""])])
    else
      CSV::Table.new(ts.collect { |x| x.to_csv})
    end
  end

  def self.trip_table
    render :partial => "club_trips/trip_table", :locals => { :club_trips => ClubTrip.all }
  end

  def to_csv
    CSV::Row.new(["Trip","When","Where","Meet","E-Room","Limit","Leader","Contact"],
                       [trip,swhen,where,meet,e_room,limit,leader,contact]);
  end

end
