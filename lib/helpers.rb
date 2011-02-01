# encoding: utf-8
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering

def current_path?(path, match_parent = true)
  path = path.is_a?(Nanoc3::Item) ? path.path : path

  if @item_rep && (match_parent && path != '/' && @item_rep.path =~ /^#{path.gsub(/(index)?\.\w+$/, '')}/) || (path == @item_rep.path) || (path == '/' && @item[:menu_root])
    true
  else
    false
  end
end

def link_to_with_current(text, path, attributes={})
  match_parent = attributes.has_key?(:parent) ? attributes.delete(:parent) : true
  target_path = path.is_a?(Nanoc3::Item) ? path.path : path
  path = attributes.delete(:parent_path) || target_path


  if current_path?(path, match_parent)
    if attributes[:class].nil?
      attributes[:class] = 'active'
    else
      attributes[:class] += ' active'
    end
  end

  link_to(text, target_path, attributes)
end
