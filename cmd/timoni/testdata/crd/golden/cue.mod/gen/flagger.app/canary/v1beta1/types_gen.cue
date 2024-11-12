// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f testdata/crd/source/flagger.crds.yaml

package v1beta1

import (
	"strings"
	"list"
)

// Canary is the Schema for the Canary API.
#Canary: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "flagger.app/v1beta1"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "Canary"
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

	// CanarySpec defines the desired state of a Canary.
	spec!: #CanarySpec
}

// CanarySpec defines the desired state of a Canary.
#CanarySpec: {
	// Canary analysis for this canary
	analysis!: matchN(1, [{
		interval!:   _
		threshold!:  _
		iterations!: _
	}, {
		interval!:   _
		threshold!:  _
		stepWeight!: _
	}, {
		interval!:    _
		threshold!:   _
		stepWeights!: _
	}]) & {
		// Alert list for this canary analysis
		alerts?: [...{
			// Name of the this alert
			name!: string

			// Alert provider reference
			providerRef!: {
				// Name of the alert provider
				name!: string

				// Namespace of the alert provider
				namespace?: string
			}

			// Severity level can be info, warn, error (default info)
			severity?: "" | "info" | "warn" | "error"
		}]

		// Percentage of pods that need to be available to consider canary
		// as ready
		canaryReadyThreshold?: number

		// Schedule interval for this canary
		interval?: =~"^[0-9]+(m|s)"

		// Number of checks to run for A/B Testing and Blue/Green
		iterations?: number

		// A/B testing match conditions
		match?: [...{
			headers?: {
				[string]: matchN(1, [{
					exact!: _
				}, {
					prefix!: _
				}, {
					suffix!: _
				}, {
					regex!: _
				}]) & {
					exact?:  string
					prefix?: string

					// RE2 style regex-based match
					// (https://github.com/google/re2/wiki/Syntax)
					regex?:  string
					suffix?: string
				}
			}

			// Query parameters for matching.
			queryParams?: {
				[string]: matchN(1, [matchN(0, [matchN(>=1, [null | bool | number | string | [...] | {
					exact!: _
				}, null | bool | number | string | [...] | {
					prefix!: _
				}, null | bool | number | string | [...] | {
					regex!: _
				}])]) & {}, {
					exact!: _
				}, {
					prefix!: _
				}, {
					regex!: _
				}]) & {
					exact?:  string
					prefix?: string

					// RE2 style regex-based match
					// (https://github.com/google/re2/wiki/Syntax).
					regex?: string
				}
			}

			// Applicable only when the 'mesh' gateway is included in the
			// service.gateways list
			sourceLabels?: {
				[string]: string
			}
		}]

		// Max traffic weight routed to canary
		maxWeight?: number

		// Metric check list for this canary
		metrics?: [...{
			// Interval of the query
			interval?: =~"^[0-9]+(m|s)"

			// Name of the metric
			name!: string

			// Prometheus query
			query?: string

			// Metric template reference
			templateRef?: {
				// Name of this metric template
				name!: string

				// Namespace of this metric template
				namespace?: string
			}

			// Additional variables to be used in the metrics query (key-value
			// pairs)
			templateVariables?: {
				[string]: string
			}

			// Max value accepted for this metric
			threshold?: number

			// Range accepted for this metric
			thresholdRange?: {
				// Max value accepted for this metric
				max?: number

				// Min value accepted for this metric
				min?: number
			}
		}]

		// Mirror traffic to canary
		mirror?: bool

		// Weight of traffic to be mirrored
		mirrorWeight?: number

		// Percentage of pods that need to be available to consider
		// primary as ready
		primaryReadyThreshold?: number

		// SessionAffinity represents the session affinity settings for a
		// canary run.
		sessionAffinity?: {
			// CookieName is the key that will be used for the session
			// affinity cookie.
			cookieName!: string

			// MaxAge indicates the number of seconds until the session
			// affinity cookie will expire.
			maxAge?: number | *86400
		}

		// Incremental traffic step weight for the analysis phase
		stepWeight?: number

		// Incremental traffic step weight for the promotion phase
		stepWeightPromotion?: number

		// Incremental traffic step weights for the analysis phase
		stepWeights?: [...number]

		// Max number of failed checks before rollback
		threshold?: number

		// Webhook list for this canary
		webhooks?: [...{
			// Metadata (key-value pairs) for this webhook
			metadata?: {
				[string]: string
			}

			// Mute all alerts for the webhook
			muteAlert?: bool

			// Name of the webhook
			name!: string

			// Number of retries for this webhook
			retries?: number

			// Request timeout for this webhook
			timeout?: =~"^[0-9]+(m|s)"

			// Type of the webhook pre, post or during rollout
			type?: "" | "confirm-rollout" | "pre-rollout" | "rollout" | "confirm-promotion" | "post-rollout" | "event" | "rollback" | "confirm-traffic-increase"

			// URL address of this webhook
			url!: string
		}]
	}

	// Scaler selector
	autoscalerRef?: {
		apiVersion!: string
		kind!:       "HorizontalPodAutoscaler" | "ScaledObject"
		name!:       string
		primaryScalerQueries?: {
			[string]: string
		}
		primaryScalerReplicas?: {
			maxReplicas?: number
			minReplicas?: number
		}
	}

	// Ingress selector
	ingressRef?: {
		apiVersion!: string
		kind!:       "Ingress"
		name!:       string
	}

	// Prometheus URL
	metricsServer?: string

	// Deployment progress deadline
	progressDeadlineSeconds?: number

	// Traffic managent provider
	provider?: string

	// Revert mutated resources to original spec on deletion
	revertOnDeletion?: bool

	// APISIX route selector
	routeRef?: {
		apiVersion!: string
		kind!:       "ApisixRoute"
		name!:       string
	}

	// Kubernetes Service spec
	service!: {
		// Metadata to add to the apex service
		apex?: {
			annotations?: {
				[string]: string
			}
			labels?: {
				[string]: string
			}
		}

		// Application protocol of the port
		appProtocol?: string

		// AppMesh backend array
		backends?: [...string]

		// Metadata to add to the canary service
		canary?: {
			annotations?: {
				[string]: string
			}
			labels?: {
				[string]: string
			}
		}

		// Istio Cross-Origin Resource Sharing policy (CORS)
		corsPolicy?: {
			allowCredentials?: bool
			allowHeaders?: [...string]

			// List of HTTP methods allowed to access the resource
			allowMethods?: [...string]

			// The list of origins that are allowed to perform CORS requests.
			allowOrigin?: [...string]

			// String patterns that match allowed origins
			allowOrigins?: [...matchN(1, [{
				exact!: _
			}, {
				prefix!: _
			}, {
				regex!: _
			}]) & {
				exact?:  string
				prefix?: string
				regex?:  string
			}]
			exposeHeaders?: [...string]
			maxAge?: string
		}

		// enable behaving as a delegate VirtualService
		delegation?: bool

		// The list of parent Gateways for a HTTPRoute
		gatewayRefs?: list.MaxItems(32) & [...{
			group?: strings.MaxRunes(253) & =~"^$|^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$" | *"gateway.networking.k8s.io"
			kind?:  strings.MaxRunes(63) & strings.MinRunes(1) & =~"^[a-zA-Z]([-a-zA-Z0-9]*[a-zA-Z0-9])?$" | *"Gateway"
			name!:  strings.MaxRunes(253) & strings.MinRunes(1)
			namespace?: strings.MaxRunes(63) & strings.MinRunes(1) & {
				=~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?$"
			}
			port?: uint16 & >=1
			sectionName?: strings.MaxRunes(253) & strings.MinRunes(1) & {
				=~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$"
			}
		}]

		// The list of Istio gateway for this virtual service
		gateways?: [...string]

		// Headers operations
		headers?: {
			request?: {
				add?: {
					[string]: string
				}
				remove?: [...string]
				set?: {
					[string]: string
				}
			}
			response?: {
				add?: {
					[string]: string
				}
				remove?: [...string]
				set?: {
					[string]: string
				}
			}
		}

		// The list of host names for this service
		hosts?: [...string]

		// URI match conditions
		match?: [...{
			authority?: matchN(1, [matchN(0, [matchN(>=1, [null | bool | number | string | [...] | {
				exact!: _
			}, null | bool | number | string | [...] | {
				prefix!: _
			}, null | bool | number | string | [...] | {
				regex!: _
			}])]) & {}, {
				exact!: _
			}, {
				prefix!: _
			}, {
				regex!: _
			}]) & {
				exact?:  string
				prefix?: string

				// RE2 style regex-based match
				// (https://github.com/google/re2/wiki/Syntax).
				regex?: string
			}

			// Names of gateways where the rule should be applied.
			gateways?: [...string]
			headers?: {
				[string]: matchN(1, [matchN(0, [matchN(>=1, [null | bool | number | string | [...] | {
					exact!: _
				}, null | bool | number | string | [...] | {
					prefix!: _
				}, null | bool | number | string | [...] | {
					regex!: _
				}])]) & {}, {
					exact!: _
				}, {
					prefix!: _
				}, {
					regex!: _
				}]) & {
					exact?:  string
					prefix?: string

					// RE2 style regex-based match
					// (https://github.com/google/re2/wiki/Syntax).
					regex?: string
				}
			}

			// Flag to specify whether the URI matching should be
			// case-insensitive.
			ignoreUriCase?: bool
			method?: matchN(1, [matchN(0, [matchN(>=1, [null | bool | number | string | [...] | {
				exact!: _
			}, null | bool | number | string | [...] | {
				prefix!: _
			}, null | bool | number | string | [...] | {
				regex!: _
			}])]) & {}, {
				exact!: _
			}, {
				prefix!: _
			}, {
				regex!: _
			}]) & {
				exact?:  string
				prefix?: string

				// RE2 style regex-based match
				// (https://github.com/google/re2/wiki/Syntax).
				regex?: string
			}

			// The name assigned to a match.
			name?: string

			// Specifies the ports on the host that is being addressed.
			port?: int

			// Query parameters for matching.
			queryParams?: {
				[string]: matchN(1, [matchN(0, [matchN(>=1, [null | bool | number | string | [...] | {
					exact!: _
				}, null | bool | number | string | [...] | {
					prefix!: _
				}, null | bool | number | string | [...] | {
					regex!: _
				}])]) & {}, {
					exact!: _
				}, {
					prefix!: _
				}, {
					regex!: _
				}]) & {
					exact?:  string
					prefix?: string

					// RE2 style regex-based match
					// (https://github.com/google/re2/wiki/Syntax).
					regex?: string
				}
			}
			scheme?: matchN(1, [matchN(0, [matchN(>=1, [null | bool | number | string | [...] | {
				exact!: _
			}, null | bool | number | string | [...] | {
				prefix!: _
			}, null | bool | number | string | [...] | {
				regex!: _
			}])]) & {}, {
				exact!: _
			}, {
				prefix!: _
			}, {
				regex!: _
			}]) & {
				exact?:  string
				prefix?: string

				// RE2 style regex-based match
				// (https://github.com/google/re2/wiki/Syntax).
				regex?: string
			}
			sourceLabels?: {
				[string]: string
			}

			// Source namespace constraining the applicability of a rule to
			// workloads in that namespace.
			sourceNamespace?: string
			uri?: matchN(1, [matchN(0, [matchN(>=1, [null | bool | number | string | [...] | {
				exact!: _
			}, null | bool | number | string | [...] | {
				prefix!: _
			}, null | bool | number | string | [...] | {
				regex!: _
			}])]) & {}, {
				exact!: _
			}, {
				prefix!: _
			}, {
				regex!: _
			}]) & {
				exact?:  string
				prefix?: string

				// RE2 style regex-based match
				// (https://github.com/google/re2/wiki/Syntax).
				regex?: string
			}

			// withoutHeader has the same syntax with the header, but has
			// opposite meaning.
			withoutHeaders?: {
				[string]: matchN(1, [matchN(0, [matchN(>=1, [null | bool | number | string | [...] | {
					exact!: _
				}, null | bool | number | string | [...] | {
					prefix!: _
				}, null | bool | number | string | [...] | {
					regex!: _
				}])]) & {}, {
					exact!: _
				}, {
					prefix!: _
				}, {
					regex!: _
				}]) & {
					exact?:  string
					prefix?: string

					// RE2 style regex-based match
					// (https://github.com/google/re2/wiki/Syntax).
					regex?: string
				}
			}
		}]

		// AppMesh mesh name
		meshName?: string

		// Mirror defines a schema for a filter that mirrors requests.
		mirror?: [...{
			backendRef?: {
				group?: strings.MaxRunes(253) & =~"^$|^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$" | *""
				kind?:  strings.MaxRunes(63) & strings.MinRunes(1) & =~"^[a-zA-Z]([-a-zA-Z0-9]*[a-zA-Z0-9])?$" | *"Service"
				name!:  strings.MaxRunes(253) & strings.MinRunes(1)
				namespace?: strings.MaxRunes(63) & strings.MinRunes(1) & {
					=~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?$"
				}
				port?: uint16 & >=1
			}
		}]

		// Kubernetes service name
		name?: string

		// Container port number
		port!: number

		// Enable port dicovery
		portDiscovery?: bool

		// Container port name
		portName?: string

		// Metadata to add to the primary service
		primary?: {
			annotations?: {
				[string]: string
			}
			labels?: {
				[string]: string
			}
		}

		// Retry policy for HTTP requests
		retries?: {
			// Number of retries for a given request
			attempts?: int

			// Timeout per retry attempt for a given request
			perTryTimeout?: string

			// Specifies the conditions under which retry takes place
			retryOn?: string
		}

		// Rewrite HTTP URIs
		rewrite?: {
			authority?: string
			type?:      string
			uri?:       string
		}

		// Container target port name
		targetPort?: _

		// HTTP or gRPC request timeout
		timeout?: string

		// Istio traffic policy
		trafficPolicy?: {
			connectionPool?: {
				// HTTP connection pool settings.
				http?: {
					// Specify if http1.1 connection should be upgraded to http2 for
					// the associated destination.
					h2UpgradePolicy?: "DEFAULT" | "DO_NOT_UPGRADE" | "UPGRADE"

					// Maximum number of pending HTTP requests to a destination.
					http1MaxPendingRequests?: int

					// Maximum number of requests to a backend.
					http2MaxRequests?: int

					// The idle timeout for upstream connection pool connections.
					idleTimeout?: string

					// Maximum number of requests per connection to a backend.
					maxRequestsPerConnection?: int
					maxRetries?:               int
				}
			}

			// Settings controlling the load balancer algorithms.
			loadBalancer?: matchN(1, [{
				simple!: _
			}, {
				consistentHash!: matchN(1, [null | bool | number | string | [...] | {
					httpHeaderName!: _
				}, null | bool | number | string | [...] | {
					httpCookie!: _
				}, null | bool | number | string | [...] | {
					useSourceIp!: _
				}, null | bool | number | string | [...] | {
					httpQueryParameterName!: _
				}])
			}]) & {
				consistentHash?: {
					// Hash based on HTTP cookie.
					httpCookie?: {
						// Name of the cookie.
						name?: string

						// Path to set for the cookie.
						path?: string

						// Lifetime of the cookie.
						ttl?: string
					}

					// Hash based on a specific HTTP header.
					httpHeaderName?: string

					// Hash based on a specific HTTP query parameter.
					httpQueryParameterName?: string
					minimumRingSize?:        int

					// Hash based on the source IP address.
					useSourceIp?: bool
				}
				localityLbSetting?: {
					// Optional: only one of distribute or failover can be set.
					distribute?: [...{
						// Originating locality, '/' separated, e.g.
						from?: string

						// Map of upstream localities to traffic distribution weights.
						to?: {
							[string]: int
						}
					}]

					// enable locality load balancing, this is DestinationRule-level
					// and will override mesh wide settings in entirety.
					enabled?: bool

					// Optional: only failover or distribute can be set.
					failover?: [...{
						// Originating region.
						from?: string
						to?:   string
					}]
				}
				simple?: "ROUND_ROBIN" | "LEAST_CONN" | "RANDOM" | "PASSTHROUGH" | "LEAST_REQUEST"

				// Represents the warmup duration of Service.
				warmupDurationSecs?: string
			}

			// Settings controlling eviction of unhealthy hosts from the load
			// balancing pool.
			outlierDetection?: {
				// Minimum ejection duration.
				baseEjectionTime?: string

				// Number of 5xx errors before a host is ejected from the
				// connection pool.
				consecutive5xxErrors?: int
				consecutiveErrors?:    int

				// Number of gateway errors before a host is ejected from the
				// connection pool.
				consecutiveGatewayErrors?: int

				// Time interval between ejection sweep analysis.
				interval?:           string
				maxEjectionPercent?: int
				minHealthPercent?:   int
			}

			// Istio TLS related settings for connections to the upstream
			// service
			tls?: {
				caCertificates?: string

				// REQUIRED if mode is `MUTUAL`.
				clientCertificate?: string
				mode?:              "DISABLE" | "SIMPLE" | "MUTUAL" | "ISTIO_MUTUAL"

				// REQUIRED if mode is `MUTUAL`.
				privateKey?: string

				// SNI string to present to the server during TLS handshake.
				sni?: string
				subjectAltNames?: [...string]
			}
		}
	}

	// Skip analysis and promote canary
	skipAnalysis?: bool

	// Suspend Canary disabling/pausing all canary runs
	suspend?: bool

	// Target selector
	targetRef!: {
		apiVersion!: string
		kind!:       "DaemonSet" | "Deployment" | "Service"
		name!:       string
	}

	// Gloo Upstream selector
	upstreamRef?: {
		apiVersion!: string
		kind!:       "Upstream"
		name!:       string
		namespace?:  string
	}
}