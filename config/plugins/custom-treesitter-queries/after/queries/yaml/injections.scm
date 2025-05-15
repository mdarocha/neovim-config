; extends

; taken from https://github.com/applejag/dotfiles/blob/6b9539d44ad92df257426beacff573e1d2db4ded/nvim/after/queries/yaml/injections.scm

; GitHub Action: actions/github-script
(block_mapping_pair
  key: (flow_node) @_script_js
  (#any-of? @_script_js "script")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content (#set! priority 105))
    (#set! injection.language "javascript")))

(block_mapping_pair
  key: (flow_node) @_script_js
  (#any-of? @_script_js "script")
  value: (block_node
    (block_scalar) @injection.content (#set! priority 105)
    (#set! injection.include-children)
    (#set! injection.language "javascript")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_script_js
  (#any-of? @_script_js "script")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content (#set! priority 105)))
        (#set! injection.include-children)
        (#set! injection.language "javascript")))))

(block_mapping_pair
  key: (flow_node) @_script_js
  (#any-of? @_script_js "script")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content (#set! priority 105)
          (#set! injection.language "javascript")
          (#set! injection.include-children)
          (#offset! @injection.content 0 1 0 0))))))
