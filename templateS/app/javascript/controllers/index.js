import { application } from "./application"
import { definitionsFromContext } from "@hotwired/stimulus"

const context = require.context(".", true, /\.js$/)
application.load(definitionsFromContext(context))
