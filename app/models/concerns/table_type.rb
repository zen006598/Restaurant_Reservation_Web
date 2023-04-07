module TableType
  extend ActiveSupport::Concern
  included do
    enum :table_type, { regular_table: 0, private_room: 1, counter_seat: 2 }, default: :regular_table
  end
end