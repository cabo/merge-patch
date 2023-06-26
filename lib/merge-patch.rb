def merge_patch(orig, patch)
  if Hash === patch
    orig = {} unless Hash === orig
    patch.each do |k, v|
      if v.nil?
        orig.delete(k)
      else
        orig[k] = merge_patch(orig[k], v)
      end
    end
    orig
  else
    patch
  end
end                             # yep, that's 15 lines.
