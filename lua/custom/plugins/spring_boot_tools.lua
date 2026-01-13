return {
  {
    'JavaHello/spring-boot.nvim',
    ft = { 'java', 'yml', 'yaml', 'jproperties' },
    dependencies = {
      'mfussenegger/nvim-jdtls', -- or nvim-java, nvim-lspconfig
    },
    ---@type bootls.Config
    opts = {},
  },
}
