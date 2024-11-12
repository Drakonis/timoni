// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f testdata/crd/source/cert-manager.crds.yaml

package v1

import "strings"

// A CertificateRequest is used to request a signed certificate
// from one of the configured issuers.
// All fields within the CertificateRequest's `spec` are immutable
// after creation. A CertificateRequest will either succeed or
// fail, as denoted by its `Ready` status condition and its
// `status.failureTime` field.
// A CertificateRequest is a one-shot resource, meaning it
// represents a single point in time request for a certificate
// and cannot be re-used.
#CertificateRequest: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "cert-manager.io/v1"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "CertificateRequest"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace!: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// Specification of the desired state of the CertificateRequest
	// resource.
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	spec!: #CertificateRequestSpec
}

// Specification of the desired state of the CertificateRequest
// resource.
// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
#CertificateRequestSpec: {
	// Requested 'duration' (i.e. lifetime) of the Certificate. Note
	// that the issuer may choose to ignore the requested duration,
	// just like any other requested attribute.
	duration?: string

	// Extra contains extra attributes of the user that created the
	// CertificateRequest. Populated by the cert-manager webhook on
	// creation and immutable.
	extra?: {
		[string]: [...string]
	}

	// Groups contains group membership of the user that created the
	// CertificateRequest. Populated by the cert-manager webhook on
	// creation and immutable.
	groups?: [...string]

	// Requested basic constraints isCA value. Note that the issuer
	// may choose to ignore the requested isCA value, just like any
	// other requested attribute.
	// NOTE: If the CSR in the `Request` field has a BasicConstraints
	// extension, it must have the same isCA value as specified here.
	// If true, this will automatically add the `cert sign` usage to
	// the list of requested `usages`.
	isCA?: bool

	// Reference to the issuer responsible for issuing the
	// certificate. If the issuer is namespace-scoped, it must be in
	// the same namespace as the Certificate. If the issuer is
	// cluster-scoped, it can be used from any namespace.
	// The `name` field of the reference must always be specified.
	issuerRef!: {
		// Group of the resource being referred to.
		group?: string

		// Kind of the resource being referred to.
		kind?: string

		// Name of the resource being referred to.
		name!: string
	}

	// The PEM-encoded X.509 certificate signing request to be
	// submitted to the issuer for signing.
	// If the CSR has a BasicConstraints extension, its isCA attribute
	// must match the `isCA` value of this CertificateRequest. If the
	// CSR has a KeyUsage extension, its key usages must match the
	// key usages in the `usages` field of this CertificateRequest.
	// If the CSR has a ExtKeyUsage extension, its extended key
	// usages must match the extended key usages in the `usages`
	// field of this CertificateRequest.
	request!: string

	// UID contains the uid of the user that created the
	// CertificateRequest. Populated by the cert-manager webhook on
	// creation and immutable.
	uid?: string

	// Requested key usages and extended key usages.
	// NOTE: If the CSR in the `Request` field has uses the KeyUsage
	// or ExtKeyUsage extension, these extensions must have the same
	// values as specified here without any additional values.
	// If unset, defaults to `digital signature` and `key
	// encipherment`.
	usages?: [..."signing" | "digital signature" | "content commitment" | "key encipherment" | "key agreement" | "data encipherment" | "cert sign" | "crl sign" | "encipher only" | "decipher only" | "any" | "server auth" | "client auth" | "code signing" | "email protection" | "s/mime" | "ipsec end system" | "ipsec tunnel" | "ipsec user" | "timestamping" | "ocsp signing" | "microsoft sgc" | "netscape sgc"]

	// Username contains the name of the user that created the
	// CertificateRequest. Populated by the cert-manager webhook on
	// creation and immutable.
	username?: string
}
