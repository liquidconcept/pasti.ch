# encoding: utf-8
# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def item_id(item)
  item.identifier.gsub(/^\/(.+)\/$/, '\1').gsub(/[\/_]+/, '-')
end
