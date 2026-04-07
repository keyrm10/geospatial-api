export class FormatNotSupportedError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'FormatNotSupportedError'
  }
}

export class ResultTooLargeError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'ResultTooLargeError'
  }
}

export class ErrorUpstream extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'ErrorUpstream'
  }
}
