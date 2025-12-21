-- ============================================================================
-- SUPABASE TABLE SETUP FOR BREADBOX POS
-- Run each SQL block separately in Supabase SQL Editor
-- ============================================================================

-- Products Table
CREATE TABLE IF NOT EXISTS public.products (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT,
  barcode TEXT UNIQUE,
  price NUMERIC(10, 2) DEFAULT 0,
  cost_price NUMERIC(10, 2) DEFAULT 0,
  quantity INTEGER DEFAULT 0,
  batch_date TIMESTAMP,
  expiry_date TIMESTAMP,
  low_stock_alert INTEGER DEFAULT 1,
  expiry_alert INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers Table
CREATE TABLE IF NOT EXISTS public.customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  loyalty_points INTEGER DEFAULT 0,
  total_spent NUMERIC(10, 2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sales Table (POS transactions)
CREATE TABLE IF NOT EXISTS public.sales (
  id TEXT PRIMARY KEY,
  customer_id TEXT,
  subtotal NUMERIC(10, 2) DEFAULT 0,
  tax NUMERIC(10, 2) DEFAULT 0,
  discount NUMERIC(10, 2) DEFAULT 0,
  total NUMERIC(10, 2) NOT NULL,
  items JSONB DEFAULT '[]'::jsonb,
  method TEXT DEFAULT 'cash',
  currency_symbol TEXT DEFAULT '$',
  currency_code TEXT DEFAULT 'USD',
  user_id UUID,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wastage Logs Table
CREATE TABLE IF NOT EXISTS public.wastage_logs (
  id TEXT PRIMARY KEY,
  product_id TEXT,
  quantity INTEGER NOT NULL,
  reason TEXT,
  user_id UUID,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stock Operations Table (adjustments, receipts, returns)
CREATE TABLE IF NOT EXISTS public.stock_operations (
  id TEXT PRIMARY KEY,
  product_id TEXT,
  operation_type TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  notes TEXT,
  user_id UUID,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Settings Table (tax rates, currency, etc.)
CREATE TABLE IF NOT EXISTS public.settings (
  id TEXT PRIMARY KEY,
  user_id UUID,
  tax_rate NUMERIC(5, 2) DEFAULT 0,
  currency_code TEXT DEFAULT 'USD',
  currency_symbol TEXT DEFAULT '$',
  business_name TEXT,
  business_address TEXT,
  business_phone TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
