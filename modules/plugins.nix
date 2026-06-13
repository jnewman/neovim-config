{ pkgs, octo-nvim-src }:
let
  plugins = [
    {
      name = "catppuccin-nvim";
      pkg = pkgs.vimPlugins.catppuccin-nvim;
    }
    {
      name = "cyberdream-nvim";
      pkg = pkgs.vimPlugins.cyberdream-nvim;
    }
    {
      name = "tokyonight-nvim";
      pkg = pkgs.vimPlugins.tokyonight-nvim;
    }
    {
      name = "kanagawa-nvim";
      pkg = pkgs.vimPlugins.kanagawa-nvim;
    }
    {
      name = "vim-moonfly-colors";
      pkg = pkgs.vimPlugins.vim-moonfly-colors;
    }
    {
      name = "melange-nvim";
      pkg = pkgs.vimPlugins.melange-nvim;
    }
    {
      name = "onenord-nvim";
      pkg = pkgs.vimPlugins.onenord-nvim;
    }
    {
      name = "miasma-nvim";
      pkg = pkgs.vimPlugins.miasma-nvim;
    }
    {
      name = "aurora";
      pkg = pkgs.vimPlugins.aurora;
    }
    {
      name = "nvim-treesitter";
      pkg = pkgs.vimPlugins.nvim-treesitter;
    }
    {
      name = "conform-nvim";
      pkg = pkgs.vimPlugins.conform-nvim;
    }
    {
      name = "plenary-nvim";
      pkg = pkgs.vimPlugins.plenary-nvim;
    }
    {
      name = "telescope-nvim";
      pkg = pkgs.vimPlugins.telescope-nvim;
    }
    {
      name = "octo-nvim";
      pkg = pkgs.vimPlugins.octo-nvim.overrideAttrs (_: {
        src = octo-nvim-src;
        version = "HEAD";
        postPatch = ''
          # Remove explicit fragment references that are already returned by
          # get_{pr,issue}_timeline_definitions(), eliminating duplicates that
          # cause gh to reject queries with "Fragment name must be unique".
          substituteInPlace lua/octo/gh/mutations.lua \
            --replace-warn \
              "fragments.cross_referenced_event .. fragments.issue .. fragments.pull_request .. fragments.connected_event .. fragments.convert_to_draft_event .. fragments.milestoned_event .. fragments.demilestoned_event .. fragments.reaction_groups .. fragments.label_connection .. fragments.label .. fragments.assignee_connection .. fragments.issue_comment .. fragments.pull_request_review .. fragments.pull_request_commit .. fragments.review_request_removed_event .. fragments.merged_event .. fragments.review_requested_event .. fragments.renamed_title_event .. fragments.review_dismissed_event .. fragments.pull_request_timeline_items_connection .. fragments.review_thread_information .. fragments.review_thread_comment .. fragments.get_pr_timeline_definitions()" \
              "fragments.issue .. fragments.pull_request .. fragments.reaction_groups .. fragments.label_connection .. fragments.label .. fragments.assignee_connection .. fragments.pull_request_timeline_items_connection .. fragments.review_thread_information .. fragments.review_thread_comment .. fragments.get_pr_timeline_definitions()" \
            --replace-warn \
              "fragments.cross_referenced_event .. fragments.issue .. fragments.pull_request .. fragments.connected_event .. fragments.convert_to_draft_event .. fragments.milestoned_event .. fragments.demilestoned_event .. fragments.reaction_groups .. fragments.label_connection .. fragments.label .. fragments.assignee_connection .. fragments.issue_comment .. fragments.pull_request_review .. fragments.pull_request_commit .. fragments.review_request_removed_event .. fragments.review_requested_event .. fragments.merged_event .. fragments.review_dismissed_event .. fragments.pull_request_timeline_items_connection .. fragments.review_thread_information .. fragments.review_thread_comment .. fragments.get_pr_timeline_definitions()" \
              "fragments.issue .. fragments.pull_request .. fragments.reaction_groups .. fragments.label_connection .. fragments.label .. fragments.assignee_connection .. fragments.pull_request_timeline_items_connection .. fragments.review_thread_information .. fragments.review_thread_comment .. fragments.get_pr_timeline_definitions()" \
            --replace-warn \
              "fragments.cross_referenced_event .. fragments.issue .. fragments.pull_request .. fragments.connected_event .. fragments.milestoned_event .. fragments.demilestoned_event .. fragments.reaction_groups .. fragments.label_connection .. fragments.label .. fragments.assignee_connection .. fragments.issue_comment .. fragments.issue_timeline_items_connection .. fragments.issue_information .. fragments.get_issue_timeline_definitions()" \
              "fragments.issue .. fragments.pull_request .. fragments.reaction_groups .. fragments.label_connection .. fragments.label .. fragments.assignee_connection .. fragments.issue_timeline_items_connection .. fragments.issue_information .. fragments.get_issue_timeline_definitions()" \
            --replace-warn \
              "fragments.cross_referenced_event .. fragments.issue .. fragments.pull_request .. fragments.connected_event .. fragments.milestoned_event .. fragments.demilestoned_event .. fragments.label_connection .. fragments.label .. fragments.reaction_groups .. fragments.assignee_connection .. fragments.issue_comment .. fragments.issue_timeline_items_connection .. fragments.issue_information .. fragments.get_issue_timeline_definitions()" \
              "fragments.issue .. fragments.pull_request .. fragments.label_connection .. fragments.label .. fragments.reaction_groups .. fragments.assignee_connection .. fragments.issue_timeline_items_connection .. fragments.issue_information .. fragments.get_issue_timeline_definitions()"
        '';
      });
    }
    {
      name = "diffview-nvim";
      pkg = pkgs.vimPlugins.diffview-nvim;
    }
    {
      name = "gitsigns-nvim";
      pkg = pkgs.vimPlugins.gitsigns-nvim;
    }
    {
      name = "blink-cmp";
      pkg = pkgs.vimPlugins.blink-cmp;
    }
    {
      name = "oil-nvim";
      pkg = pkgs.vimPlugins.oil-nvim;
    }
    {
      name = "which-key-nvim";
      pkg = pkgs.vimPlugins.which-key-nvim;
    }
    {
      name = "nvim-autopairs";
      pkg = pkgs.vimPlugins.nvim-autopairs;
    }
    {
      name = "comment-nvim";
      pkg = pkgs.vimPlugins.comment-nvim;
    }
    {
      name = "lualine-nvim";
      pkg = pkgs.vimPlugins.lualine-nvim;
    }
    {
      name = "indent-blankline-nvim";
      pkg = pkgs.vimPlugins.indent-blankline-nvim;
    }
    {
      name = "flash-nvim";
      pkg = pkgs.vimPlugins.flash-nvim;
    }
    {
      name = "SchemaStore-nvim";
      pkg = pkgs.vimPlugins.SchemaStore-nvim;
    }
  ];
in
pkgs.runCommand "nvim-plugin-pack" { } ''
  mkdir -p $out/pack/nix/start
  ${pkgs.lib.concatMapStrings (p: ''
    cp -rL ${p.pkg} $out/pack/nix/start/${p.name}
  '') plugins}
''
