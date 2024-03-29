library;

use ::convert::TryFrom;
use ::option::Option::{self, *};

impl TryFrom<u32> for u16 {
    fn try_from(u: u32) -> Option<Self> {
        if u > u16::max().as_u32() {
            None
        } else {
            Some(asm(r1: u) {
                r1: u16
            })
        }
    }
}

impl TryFrom<u64> for u16 {
    fn try_from(u: u64) -> Option<Self> {
        if u > u16::max().as_u64() {
            None
        } else {
            Some(asm(r1: u) {
                r1: u16
            })
        }
    }
}

impl TryFrom<u256> for u16 {
    fn try_from(u: u256) -> Option<Self> {
        let parts = asm(r1: u) {
            r1: (u64, u64, u64, u64)
        };

        if parts.0 != 0
            || parts.1 != 0
            || parts.2 != 0
            || parts.3 > u16::max().as_u64()
        {
            None
        } else {
            Some(asm(r1: parts.3) {
                r1: u16
            })
        }
    }
}

#[test]
fn test_u16_try_from_u32() {
    use ::assert::assert;

    let u32_1: u32 = 2u32;
    let u32_2: u32 = u16::max().as_u32() + 1;

    let u16_1 = <u16 as TryFrom<u32>>::try_from(u32_1);
    let u16_2 = <u16 as TryFrom<u32>>::try_from(u32_2);

    assert(u16_1.is_some());
    assert(u16_1.unwrap() == 2u16);

    assert(u16_2.is_none());
}

#[test]
fn test_u16_try_from_u64() {
    use ::assert::assert;

    let u64_1: u64 = 2;
    let u64_2: u64 = u16::max().as_u64() + 1;

    let u16_1 = <u16 as TryFrom<u64>>::try_from(u64_1);
    let u16_2 = <u16 as TryFrom<u64>>::try_from(u64_2);

    assert(u16_1.is_some());
    assert(u16_1.unwrap() == 2u16);

    assert(u16_2.is_none());
}

#[test]
fn test_u16_try_from_u256() {
    use ::assert::assert;

    let u256_1: u256 = 0x0000000000000000000000000000000000000000000000000000000000000002u256;
    let u256_2: u256 = 0x1000000000000000000000000000000000000000000000000000000000000000u256;

    let u16_1 = <u16 as TryFrom<u256>>::try_from(u256_1);
    let u16_2 = <u16 as TryFrom<u256>>::try_from(u256_2);

    assert(u16_1.is_some());
    assert(u16_1.unwrap() == 2u16);

    assert(u16_2.is_none());
}
