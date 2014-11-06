module WCC::Auth

  ACCESS_LEVELS = [
    { id: nil, name: "None", slug: "none", description: "no access", level: 0 },
    { id: 1, name: "Basic", slug: "basic", description: "read access", level: 1 },
    { id: 2, name: "Contribute", slug: "contribute", description: "read-write of data user owns", level: 2 },
    { id: 3, name: "Manage", slug: "manage", description: "read-write of other's data", level: 3 },
    { id: 4, name: "App Admin", slug: "appadmin", description: "read-write app configuration", level: 4 },
    { id: 5, name: "System Admin", slug: "sysadmin", description: "full access", level: 5 },
  ]

  AccessLevel = Struct.new(:id, :name, :slug, :description, :level) do
    include Comparable

    def <=>(record)
      self.level <=> record.level
    end

    def self.[](index_or_slug, db=ACCESS_LEVELS)
      all(db).find do |al|
        al.level.to_s === index_or_slug.to_s ||
          al.slug === index_or_slug.to_s
      end
    end

    def self.all(db=ACCESS_LEVELS)
      db.collect do |row|
        new.tap { |access_level|
          row.each { |field, value|
            access_level[field] = value
          }
        }
      end.sort
    end

  end

end
