class Api::BaseController < ApplicationController
  protect_from_forgery

  def success_handler response
    format 200, 'OK', 'OK', response
  end

  def error_handler code
    case code
    when 404
      format code,'Not Found','要求されたコンテンツは存在しません',''
    when 422
      format code,'Unprocessable Entity','不正なリクエスト',''
    when 500
      format code,'Internal Server Error','内部エラー',''
    when 503
      format code,'Service Unavailable','一時的にサービスを提供することができません',''
    else
      format code,'Unprocessable Entity','不正なリクエスト',''
    end
  end

  def format code,status,message,response
    if response != ''
      result = {
        meta: {
          code: code,
          status: status,
          message: message
        },
        response: response
      }
    else
      result = {
        meta: {
          code: code,
          status: status,
          message: message
        }
      }
    end

    render json: result
  end
end
