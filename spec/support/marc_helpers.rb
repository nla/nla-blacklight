module MarcHelpers
  def load_marc_from_file(id)
    IO.read("spec/files/marc/#{id}.marcxml")
  end
end
