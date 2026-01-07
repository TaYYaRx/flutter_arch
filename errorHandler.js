/**
 * Gelişmiş Error Handler Middleware
 * Tüm hataların GERÇEK NEDENLERİNİ kullanıcıya gösterir
 */

const errorHandler = (err, req, res, next) => {
  // Hata logla (sunucu tarafında)
  console.error("❌ Hata Detayı:", {
    name: err.name,
    message: err.message,
    code: err.code,
    path: req.path,
    method: req.method,
  });
  console.error("Stack Trace:", err.stack);

  // 1. Mongoose Validation Hatası
  if (err.name === "ValidationError") {
    const errors = Object.values(err.errors).map((e) => ({
      field: e.path,
      value: e.value,
      message: e.message,
      kind: e.kind,
    }));

    return res.status(400).json({
      success: false,
      errorType: "ValidationError",
      message: "Veri doğrulama hatası",
      errors: errors,
      // Gerçek hata detayı
      details: {
        failedFields: errors.map((e) => e.field),
        originalError: err.message,
      },
    });
  }

  // 2. Mongoose CastError (geçersiz ObjectId veya tip hatası)
  if (err.name === "CastError") {
    return res.status(400).json({
      success: false,
      errorType: "CastError",
      message: "Geçersiz veri formatı",
      // Gerçek hata nedeni
      details: {
        field: err.path,
        value: err.value,
        expectedType: err.kind,
        reason: `'${err.value}' değeri '${err.path}' alanı için geçerli bir ${err.kind} değil`,
        originalError: err.message,
      },
    });
  }

  // 3. MongoDB Duplicate Key Error (11000)
  if (err.code === 11000) {
    const field = Object.keys(err.keyPattern)[0];
    const value = err.keyValue[field];

    return res.status(400).json({
      success: false,
      errorType: "DuplicateKeyError",
      message: "Tekrar eden kayıt hatası",
      // Gerçek hata nedeni
      details: {
        field: field,
        value: value,
        reason: `'${field}' alanında '${value}' değeri zaten mevcut`,
        originalError: err.message,
      },
    });
  }

  // 4. MongoDB Connection Error
  if (
    err.name === "MongoNetworkError" ||
    err.name === "MongooseServerSelectionError"
  ) {
    return res.status(503).json({
      success: false,
      errorType: err.name,
      message: "Veritabanı bağlantı hatası",
      details: {
        reason: "MongoDB sunucusuna bağlanılamıyor",
        originalError: err.message,
      },
    });
  }

  // 5. JWT Error (eğer ileride JWT kullanırsanız)
  if (err.name === "JsonWebTokenError") {
    return res.status(401).json({
      success: false,
      errorType: "JsonWebTokenError",
      message: "Geçersiz token",
      details: {
        reason: err.message,
      },
    });
  }

  if (err.name === "TokenExpiredError") {
    return res.status(401).json({
      success: false,
      errorType: "TokenExpiredError",
      message: "Token süresi dolmuş",
      details: {
        expiredAt: err.expiredAt,
        reason: err.message,
      },
    });
  }

  // 6. Custom Application Errors (özel hata sınıfları için)
  if (err.isOperational) {
    return res.status(err.statusCode || 400).json({
      success: false,
      errorType: "ApplicationError",
      message: err.message,
      details: err.details || {},
    });
  }

  // 7. Genel Hatalar (beklenmeyen hatalar)
  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    success: false,
    errorType: err.name || "UnknownError",
    message: err.message || "Sunucu hatası",
    // Gerçek hata detayı
    details: {
      path: req.path,
      method: req.method,
      timestamp: new Date().toISOString(),
      originalError: err.message,
      // Stack trace sadece development'ta
      ...(process.env.NODE_ENV === "development" && {
        stack: err.stack,
        fullError: err,
      }),
    },
  });
};

module.exports = errorHandler;
