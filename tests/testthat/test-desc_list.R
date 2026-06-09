test_that("des_list contains all relevant info", {
  descriptor_list <- desc_list()

  # Table names
  expect_equal(
    names(descriptor_list),
    c("class", "fun", "description", "param1", "param2")
  )

  # Descriptor list
  expect_equal(
    descriptor_list$fun,
    c(
      "Ap",
      "Tp",
      "Cnf",
      "Cmax",
      "Cmed",
      "Isof",
      "p",
      "Cwf",
      "Cwmax",
      "Cwmed",
      "Inc"
    )
  )
})

test_that(".rbind_fill_base works as expected", {
  testbind <- .rbind_fill_base(data.frame(A = 1), data.frame(B = 1))
  expect_true(is.na(testbind$A[2]))
  expect_true(is.na(testbind$B[1]))
})
