return {
    "rcarriga/nvim-notify",
    config = function()
        vim.notify = require("notify")
        vim.notify("Notify works!", "Notify")
        require("notify").setup({
            background_colour = "#000000",
        })
    end
}
